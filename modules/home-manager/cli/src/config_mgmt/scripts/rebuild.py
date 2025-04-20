import click
import subprocess
import os


@click.group
def rebuild():
    pass


@rebuild.command()
@click.option(
    "--rollback/--no-update",
    default=False,
    help="Rollback to previous version",
    type=bool,
)
@click.option(
    "--update/--no-update",
    default=False,
    help="Update inputs before rebuild",
    type=bool,
)
@click.option(
    "--switch/--no-switch",
    default=False,
    help="Do not switch to newly built config",
    type=bool,
)
def user(rollback: bool, update: bool, switch: bool):
    """Command that rebuilds the current user home-manager config"""

    args: list[str] = (
        [
            "home-manager",
            "switch" if switch else "build",
            "--flake",
            os.path.expanduser("~/.dotfiles/#user"),
        ]
        + (["--rollback"] if rollback else [])
        + (["--update"] if update else [])
    )

    subprocess.run(args).check_returncode()


@rebuild.command()
@click.option(
    "--rollback/--no-update",
    default=False,
    help="Rollback to previous version",
    type=bool,
)
@click.option(
    "--update/--no-update",
    default=False,
    help="Update inputs before rebuild",
    type=bool,
)
@click.option(
    "--switch/--no-switch",
    default=False,
    help="Do not switch to newly built config",
    type=bool,
)
def system(rollback: bool, update: bool, switch: bool):
    """Command that rebuilds the system config"""

    args: list[str] = (
        [
            "sudo",
            "nixos-rebuild",
            "switch" if switch else "build",
            "--flake",
            os.path.expanduser("~/.dotfiles/#system"),
        ]
        + (["--rollback"] if rollback else [])
        + (["--update"] if update else [])
    )
    subprocess.run(args).check_returncode()


@rebuild.command()
@click.option(
    "--rollback/--no-update",
    default=False,
    help="Rollback to previous version",
    type=bool,
)
@click.option(
    "--update/--no-update",
    default=False,
    help="Update inputs before rebuild",
    type=bool,
)
@click.option(
    "--switch/--no-switch",
    default=False,
    help="Do not switch to newly built config",
    type=bool,
)
def all(rollback: bool, update: bool, switch: bool):
    """Command that rebuilds the system and user configs"""

    system_args: list[str] = (
        [
            "sudo",
            "nixos-rebuild",
            "switch" if switch else "build",
            "--flake",
            os.path.expanduser("~/.dotfiles/#system"),
        ]
        + (["--rollback"] if rollback else [])
        + (["--update"] if update else [])
    )

    user_args: list[str] = (
        [
            "home-manager",
            "switch" if switch else "build",
            "--flake",
            os.path.expanduser("~/.dotfiles/#user"),
        ]
        + (["--rollback"] if rollback else [])
        + (["--update"] if update else [])
    )

    subprocess.run(system_args).check_returncode()

    subprocess.run(user_args).check_returncode()


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
