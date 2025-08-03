import sys

import click

from config_mgmt.scripts.config import config

from obsidian.scripts.notes import notes

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


@mycli.command
def test():
    print(sys.path)


mycli.add_command(config)
mycli.add_command(notes)
