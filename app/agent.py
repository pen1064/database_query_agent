from app.llm_gateway import LLMGateway
from app.tools import calculator, db_query, check_schema
from app.utils.safe_load_json import safe_load_json
from app.prompts import construct_system_prompt


class ThoughtAgent:
    def __init__(self):
        self.llm = LLMGateway()

    async def think_step(self, question: str, history: list) -> dict:
        context = "\n".join(history[-6:])
        prompt = construct_system_prompt(question=question, context=context)

        response = await self.llm.ask(prompt)
        plan = safe_load_json(response)
        return plan

    async def run(self, question: str, max_steps: int = 5):
        history = [f"Question: {question}"]
        for step in range(max_steps):
            print(f"\n🧠 STEP {step+1} ----------------------------", flush=True)
            plan = await self.think_step(question, history)
            print(f'plan {plan}', flush=True)
            history.append(
                f"Thought {step+1}: {plan['thought']}\n Next Action: {plan.get('next_action', 'nothing')}"
                f"\n Next Action Input: {plan['next_action_input']} "
            )

            if plan["next_action"] == "calculator":
                observation = await calculator(plan["next_action_input"])
            elif plan["next_action"] == "check_schema":
                observation = await check_schema()
            elif plan["next_action"] == "db_query":
                observation = await db_query(plan["next_action_input"])
            else:
                observation = "No action."

            history.append(f"Observation: {observation}")

            if plan.get("finish"):
                break

        final_prompt = f"""
            Based on all reasoning and observations, provide the final summarized answer.
            
            {chr(10).join(history)}
        """
        answer = await self.llm.ask(final_prompt)
        return answer, history
