import click
import subprocess
import os


@click.group
def home_manager():
    pass


@home_manager.command()
# @click.option("--count", default=1, help="Number of greetings.")
# @click.option("--name", prompt="Your name", help="The person to greet.")
def switch():
    """Command that rebuilds the current user home-manager config"""
    subprocess.run(
        [
            "home-manager",
            "switch",
            "--flake",
            os.path.expanduser("~/.dotfiles/#user"),
        ]
    ).check_returncode()


# @click.command()
## @click.option("--count", default=1, help="Number of greetings.")
## @click.option("--name", prompt="Your name", help="The person to greet.")
# def rollback():
# """Command that rebuilds the current user home-manager config"""
# subprocess.run(["home-manage", "switch", "--flake", "./#user"]).check_returncode()
#
# @click.command()
## @click.option("--count", default=1, help="Number of greetings.")
## @click.option("--name", prompt="Your name", help="The person to greet.")
# def update():
# """Command that rebuilds the current user home-manager config"""
# subprocess.run(["home-manage", "switch", "--flake", "./#user"]).check_returncode()
