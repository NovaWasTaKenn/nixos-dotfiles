import click
import subprocess
import os


@click.group
def config():
    pass


@config.command()
def system_clean():
    nix_clean = "sudo nix-collect-garbage -d".split(" ")
    home_clean = "home-manager expire-generations -d".split(" ")
    nix_orphans = "nix store gc && sudo nix store optimize".split(" ")
    nix_wipe = "sudo nix profile wipe-history".split(" ")
    hm_clean_old = "home-manager remove-generations old".split(" ")

    subprocess.run(
        nix_clean
        + ["&&"]
        + home_clean
        + ["&&"]
        + nix_orphans
        + ["&&"]
        + nix_wipe
        + ["&&"]
        + hm_clean_old
    ).check_returncode()


@config.command()
@click.argument("flakeinput", nargs=1, type=str)
@click.option(
    "--flakepath",
    default="~/.dotfiles/",
    help="path to the flake to update",
    type=str,
)
def update(flakeinput: str, flakepath: str):
    """Command that update a flake's input. By default updates the config's main flake"""

    subprocess.run(
        [
            "nix",
            "flake",
            "update",
            flakeinput,
            "--flake",
            os.path.expanduser(flakepath),
        ]
    ).check_returncode()


@config.command()
@click.argument("flakeinput", nargs=1, type=str)
@click.option(
    "--packagename",
    help="Name of the package to build",
    type=str,
)
def reload(flakeinput: str, packagename: str):
    """Command that builds packageName package, updates the inputFlakeName flake input in the config and rebuilds the home config to reload the changes"""

    packagename = (
        packagename if (packagename != "" and packagename is not None) else flakeinput
    )

    subprocess.run(["nix", "build"] + [f"./#{packagename}"]).check_returncode()

    subprocess.run(
        [
            "nix",
            "flake",
            "update",
            flakeinput,
            "--flake",
            os.path.expanduser("~/.dotfiles/"),
        ]
    ).check_returncode()

    subprocess.run(
        [
            "home-manager",
            "switch",
            "--flake",
            os.path.expanduser("~/.dotfiles/#user"),
        ]
    ).check_returncode()


@config.command()
@click.option(
    "--rollback/--no-rollback",
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
def rebuild_user(rollback: bool, update: bool, switch: bool):
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


@config.command()
@click.option(
    "--rollback/--no-update",
    default=False,
    help="Rollback to previous version",
    type=bool,
)
@click.option(
    "--update/--no-update",
    default=False,
    help="Update inputs before config",
    type=bool,
)
@click.option(
    "--switch/--no-switch",
    default=False,
    help="Do not switch to newly built config",
    type=bool,
)
def rebuild_system(rollback: bool, update: bool, switch: bool):
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


@config.command()
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
def rebuild_all(rollback: bool, update: bool, switch: bool):
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
