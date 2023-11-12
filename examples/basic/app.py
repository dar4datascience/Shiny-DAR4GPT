from shiny import App, Inputs, Outputs, Session, ui
from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.
import chatstream

app_ui = ui.page_fixed(
    chatstream.chat_ui("mychat"),
)


def server(input: Inputs, output: Outputs, session: Session):
    chatstream.chat_server("mychat")


app = App(app_ui, server)