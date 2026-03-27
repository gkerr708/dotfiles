from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    default_colors, bold, reverse,
    red, green, yellow, blue, cyan
)

class Scheme(ColorScheme):
    progress_bar_color = cyan

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        # Selected file
        if context.selected:
            attr |= reverse

        if context.in_browser:
            if context.directory:
                fg, attr = blue, (attr | bold)
            elif context.executable and not any((context.media, context.fifo, context.socket)):
                fg, attr = green, (attr | bold)
            elif context.link:
                fg = cyan
            elif context.marked:
                fg, attr = yellow, (attr | bold)
            elif context.empty or context.error:
                fg = red

        return fg, bg, attr
