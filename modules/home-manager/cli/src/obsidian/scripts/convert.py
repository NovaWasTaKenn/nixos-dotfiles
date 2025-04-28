import click
import subprocess
import os


@click.group()
def convert():
    pass


@convert.command()
@click.argument("input_file", nargs=1, type=click.Path(exists=True, dir_okay=False))
@click.argument("output_file", nargs=1, type=click.Path(exists=False, dir_okay=False))
@click.option(
    "--font_size",
    default="10pt",
    show_default=True,
    type=str,
    help="Sets the pdf font size",
)
def mdpdf_pandoc(input_file, output_file, font_size: str) -> None:
    """Converts gf markdown to pdf using pandoc"""

    click.echo(f"output type : {type(output_file)}")
    if not os.path.exists(output_file):
        click.echo(f"Creating output file: {output_file}")
        os.mknod(output_file)

    click.echo(f"current working dir: {os.getcwd()}")

    pandoc_args: list[str] = [
        "pandoc",
        input_file,
        "--from=gfm+hard_line_breaks",
        "--to=pdf",
        "--pdf-engine=xelatex",
        "-V",
        f"fontsize={font_size}",
        "--standalone",
        "-o",
        f"{output_file}",
        "--template=/home/quentin/.dotfiles/cli/obsidian/pandoc/templates/eisvogel.latex",
        "--listings",
        "-V",
        "disable-header-and-footer=true",
        "-V",
        "lang=fr-FR",
        "-V",
        "colorlinks=true",
    ]

    completedProcess = subprocess.run(pandoc_args, text=True, capture_output=True)
    click.echo(f"pandoc stdout: {completedProcess.stdout}")
    click.echo(f"pandoc stderr: {completedProcess.stderr}")
    completedProcess.check_returncode()


@convert.command()
@click.argument("src", nargs=1, type=click.Path(exists=True))
@click.argument("dest", nargs=1, type=click.Path(exists=False))
@click.option(
    "--start_at",
    type=click.Path(exists=False),
    help="export only from this folder, links to notes in src vault are preserved",
)
def export(src, dest, start_at) -> None:
    """obsidian-export command, exports obsidian markdown notes from src obsidian vault to commonMarknotes in dest destination"""

    pandoc_args: list[str] = [
        "obsidian-export",
        src,
        dest,
    ] + ([f"--start_at {start_at}"] if start_at else [])

    subprocess.run(pandoc_args).check_returncode()
