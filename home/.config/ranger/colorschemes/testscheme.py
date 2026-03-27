from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, bold, reverse, red

class Scheme(ColorScheme):
    progress_bar_color = red

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        # selected item = reversed
        if context.selected:
            attr |= reverse

        # directories = bright red + bold
        if context.in_browser and context.directory:
            fg = red
            attr |= bold

        return fg, bg, attr
