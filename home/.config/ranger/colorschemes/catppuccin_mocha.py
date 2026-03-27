from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default_colors, bold, reverse

# ANSI approximations of Catppuccin Mocha
BR_BLACK, BR_RED, BR_GREEN, BR_YELLOW, BR_BLUE, BR_MAGENTA, BR_CYAN, BR_WHITE = 8, 9, 10, 11, 12, 13, 14, 15

class Scheme(ColorScheme):
    progress_bar_color = BR_MAGENTA  # Lavender

    def use(self, context):
        fg, bg, attr = default_colors
        if context.reset:
            return default_colors

        if context.selected:
            attr |= reverse

        if context.in_browser:
            if context.directory:
                fg, attr = BR_CYAN, (attr | bold)   # Sapphire
            elif context.executable and not any((context.media, context.fifo, context.socket, context.container)):
                fg, attr = BR_GREEN, (attr | bold)  # Green
            elif context.link:
                fg = BR_BLUE if context.good else BR_MAGENTA  # Blue / Mauve
            elif context.socket:
                fg = BR_MAGENTA
            elif context.fifo or context.device:
                fg = BR_YELLOW
            elif context.media:
                if context.image:
                    fg = BR_YELLOW   # Peach
                elif context.video:
                    fg = BR_RED      # Red
                elif context.audio:
                    fg = BR_CYAN     # Teal
            elif context.empty or context.error:
                fg = BR_RED          # Red

            if context.marked:
                fg, attr = BR_YELLOW, (attr | bold)  # Peach/Yellow highlight

            # 🔹 Add this block for inactive panes:
            if context.inactive_pane and not context.selected:
                fg = BR_BLACK        # dim text
                attr &= ~bold        # remove bold so it fades back

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = BR_RED if context.bad else BR_GREEN
            elif context.directory:
                fg = BR_CYAN   # Sapphire
            elif context.link:
                fg = BR_BLUE
            elif context.tab and context.good:
                bg = BR_GREEN

        elif context.in_statusbar:
            if context.permissions:
                fg = BR_GREEN if context.good else BR_RED
            if context.marked:
                fg, attr = BR_YELLOW, (attr | bold | reverse)
            if context.message and context.bad:
                fg, attr = BR_RED, (attr | bold)
            if context.loaded:
                bg = self.progress_bar_color

        return fg, bg, attr
