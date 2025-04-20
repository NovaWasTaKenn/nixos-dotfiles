import click


@click.group()
def convert():
    pass


@convert.command()
def mdpdf_pandoc():
    """Command that rebuilds the system and user configs"""

    pandoc_args: list[str] = (
        [
            "pandoc",
            "/home/quentin/Documents/personal/10-Inbox/cv-1743448272.md",
            "--from=gfm+hard_line_breaks",
            "--to=pdf",
            "--pdf-engine=xelatex",
            "-V fontsize=9pt",
            "--standalone",
            "-o /home/quentin/Documents/personal/pdf/cv-eisvogel.pdf",
            "--template /home/quentin/.dotfiles/cli/obsidian/pandoc/templates/eisvogel.latex",
            "--listings",
            "-V disable-header-and-footer=true",
            "-V lang=fr-FR",
            "-V colorlinks=true",
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
