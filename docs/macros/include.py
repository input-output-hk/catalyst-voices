import os


def inc_file(env, filename, start_line=0, end_line=None):
    """
    Include a file, optionally indicating start_line and end_line
    (start counting from 0)
    The path is relative to the top directory of the documentation
    project.
    """
    output = ""

    full_filename = os.path.join(env.project_dir, filename)

    output += f"{full_filename}\n"

    contents = os.listdir("/")
    for item in contents:
        output += f"{item}\n"

    contents = os.listdir(full_filename)
    for item in contents:
        output += f"{item}\n"

    return output

    with open(full_filename, "r") as f:
        lines = f.readlines()
    line_range = lines[start_line:end_line]
    return "".join(line_range)
