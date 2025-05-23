import click
from config_mgmt.scripts.rebuild import rebuild
from obsidian.scripts.convert import convert

# @click.command()
# @click.option("--count", default=1, help="Number of greetings.")
# @click.option("--name", prompt="Your name", help="The person to greet.")
# def hello(count, name):
# """Simple program that greets NAME for a total of COUNT times."""
# for x in range(count):
# click.echo(f"Hello {name}!")


@click.group
def mycli():
    pass


mycli.add_command(rebuild)
mycli.add_command(convert)
