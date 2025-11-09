import json
import re

def safe_load_json(text: str):
    """
    Safely parse LLM output that may include Markdown or incomplete JSON.
    """
    if not text or not isinstance(text, str):
        raise ValueError("Empty or invalid LLM response")

    cleaned = text.strip()

    # 🧹 1️⃣ Try plain JSON first
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError:
        pass

    # 🔍 2️⃣ Try to extract JSON block inside text
    match = re.search(r"\{[\s\S]*\}", cleaned)
    if match:
        try:
            return json.loads(match.group(0))
        except json.JSONDecodeError:
            pass

    # 🧩 3️⃣ Handle “Thought ...” style text fallback
    if cleaned.lower().startswith("thought"):
        print("⚠️  safe_load_json: Non-JSON text detected, wrapping it as a thought.", flush=True)
        return {
            "thought": cleaned,
            "next_action": "none",
            "next_action_input": "",
            "finish": False,
        }

    # 🚨 4️⃣ Complete failure
    raise ValueError(f"Failed to parse JSON from model output:\n{text[:500]}...")
