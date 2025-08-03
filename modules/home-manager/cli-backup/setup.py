from setuptools import setup, find_packages

setup(
    name="nova-cli",
    version="0.1.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    include_package_data=True,
    install_requires=[
        "Click",
    ],
    entry_points={
        "console_scripts": [
            "mycli=base.scripts.mycli:mycli",  # Point to the hello function in cli.py
        ],
    },
)
