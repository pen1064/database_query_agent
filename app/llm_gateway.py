import os, uuid, asyncio
import google.generativeai as genai
import google.api_core.exceptions as g_exceptions
from typing import List, Dict, Optional

class LLMGateway:
    def __init__(self):
        self.api_key = os.getenv("GOOGLE_API_KEY")
        if not self.api_key:
            raise ValueError("Missing GOOGLE_API_KEY")
        genai.configure(api_key=self.api_key)
        self.chat_model_name = os.getenv("GOOGLE_CHAT_MODEL")
        self._chat_model = genai.GenerativeModel(self.chat_model_name)

    async def chat(self, messages: List[Dict[str, str]], trace_id: str) -> str:
        prompt = "\n".join([m.get("content","") for m in messages])
        loop = asyncio.get_event_loop()

        def _sync():
            return self._chat_model.generate_content(prompt)
        try:
            result = await loop.run_in_executor(None, _sync)
            return getattr(result, "text", "[Empty or blocked response]").strip()

        except g_exceptions.InvalidArgument as e:
            print(f"[LLM ERROR] Invalid input (400): {e}")
            raise
        except g_exceptions.PermissionDenied as e:
            print(f"[LLM ERROR] Permission denied (403): {e}")
            raise
        except g_exceptions.NotFound as e:
            print(f"[LLM ERROR] Not found (404): {e}")
            raise
        except g_exceptions.InternalServerError as e:
            print(f"[LLM ERROR] Internal error (500): {e}")
            raise
        except Exception as e:
            # These exceptions don't have explicit status_code, but often include it in message
            print(f"[LLM ERROR] Unknown error: {e}")
            raise

    async def ask(self, prompt: str, trace_id: Optional[str] = None) -> str:
        local_trace_id = trace_id or str(uuid.uuid4())
        return await self.chat([{"role": "user", "content": prompt}], trace_id=local_trace_id)
