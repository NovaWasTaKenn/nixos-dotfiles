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
    "--doctype",
    default="simple",
    show_default=True,
    type=str,
    help="Sets the general document style",
)
@click.option(
    "--latex/--no-latex",
    default=False,
    type=bool,
    help="Outputs the intermediate latex instead",
)
@click.option(
    "--fontsize",
    default="10pt",
    show_default=True,
    type=str,
    help="Sets the pdf font size",
)
@click.option(
    "--lang",
    default="fr-FR",
    show_default=True,
    type=str,
    help="Sets the pdf's language",
)
def mdpdf_pandoc(
        input_file, output_file, fontsize: str, doctype: str, lang: str, latex: bool
) -> None:
    """Converts gf markdown to pdf using pandoc"""

    click.echo(f"output type : {type(output_file)}")
    if not os.path.exists(output_file):
        click.echo(f"Creating output file: {output_file}")
        os.mknod(output_file)

    click.echo(f"current working dir: {os.getcwd()}")

    if latex and not output_file.endswith(".latex"):
        raise Exception("output file must be .latex if --latex is true")
    if not latex and not output_file.endswith(".pdf"):
        raise Exception("output file must be .md if --latex is false")

    dest_format = "latex" if latex else "pdf"

    args: list[str] = [
        "pandoc",
        input_file,
        "-o",
        f"{output_file}",
        "--from=markdown+hard_line_breaks+raw_tex",
        f"--to={dest_format}",
        "--pdf-engine=xelatex",
        "--standalone",
        "--template=/home/quentin/.dotfiles/modules/home-manager/cli/src/obsidian/pandoc/templates/eisvogel.latex",
        "--listings",
        "-V",
        f"lang={lang}",
        "-V",
        f"fontsize={fontsize}",
        "-V",
        "colorlinks=true",
    ]

    if doctype == "simple":
        args += [
            "-V",
            "pagestyle=empty",
            "-V",
            "disable-header-and-footer=true",
        ]

    if doctype == "report":
        args += [
            "--toc",
            "-V",
            "toc-own-page",
            "-V",
            "titlepage",
        ]

    click.echo(f"pandoc args : {args}")
    completedProcess = subprocess.run(args, text=True, capture_output=True)
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
