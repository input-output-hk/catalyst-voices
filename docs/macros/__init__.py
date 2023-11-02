from .include import inc_file


def define_env(env):
    """
    This is the hook for defining variables, macros and filters
    """

    @env.macro
    def include_file(filename, start_line=0, end_line=None, indent=None):
        return inc_file(env, filename, start_line, end_line, indent)
