import streamlit as st
import asyncio
from app.agent import ThoughtAgent

st.set_page_config(
    page_title="Database Query Agent",
    layout="wide",
    initial_sidebar_state="expanded"
)
st.title("Database Query Agent")

col_input, col_output = st.columns([2, 3])
with col_input:
    st.subheader("Ask your question")
    question = st.text_area(
        "Enter question:",
        placeholder="e.g. Which customers from Toronto spent more than 500?",
        height=150,
        label_visibility="collapsed"  # hides redundant label
    )
    run_button = st.button("Run Agent")


with col_output:
    st.subheader("Answer / Reasoning")
    if run_button:
        if not question.strip():
            st.warning("Please enter a question first.")
        else:
            st.write("Running agent for:", question)
            agent = ThoughtAgent()

            st.subheader("Reasoning Trace")
            reasoning_box = st.empty()
            trace_output = []


            async def run_agent():
                answer, trace = await agent.run(question)
                return answer, trace


            with st.spinner("Running agent..."):
                try:
                    answer, trace = asyncio.run(run_agent())
                    for line in trace:
                        trace_output.append(line)
                        reasoning_box.text_area("Reasoning Trace", "\n\n".join(trace_output), height=400)
                    st.success("✅ Agent finished reasoning.")
                    st.markdown("### Final Answer")
                    st.write(answer)
                except Exception as e:
                    st.error(f"Error: {e}")

