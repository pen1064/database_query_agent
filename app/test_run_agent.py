import asyncio
from app.agent import ThoughtAgent
import time

questions = [
    'Which customers from Toronto spent more than 500? What did they buy?',
    'Which department spent the most in travelling? Which countries did they travel? When did they travel?',
    'Who has the highest training rating and also traveled internationally?', #HR + Learning
    'Which department owns the most expensive asset?',	#Operations
    'Which vendor supplied the most inventory items?',	#Supply Chain
    'What is the total revenue generated per product?', #E-commerce
    'Which employee took the most business trips in 2025?',	#HR
]
async def main():
    agent = ThoughtAgent()
    for question in questions:
        answer, trace = await agent.run(question)
        #print("=== REASONING TRACE ===")
        #print("\n".join(trace))
        print("\n=== FINAL ANSWER ===")
        print(answer)
        time.sleep(10)

if __name__ == "__main__":
    asyncio.run(main())
