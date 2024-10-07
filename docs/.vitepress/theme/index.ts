// https://vitepress.dev/guide/custom-theme
import { h } from "vue";
import type { Theme } from "vitepress";
import DefaultTheme from "vitepress/theme";
import "./style.css";
import { trackLinksAndFathomEvents } from "./analytics";
import { scrollableRegionsHaveKeyboardAccess } from "./accessibility";

export default {
  extends: DefaultTheme,
  Layout: () => {
    return h(DefaultTheme.Layout, null, {
      // https://vitepress.dev/guide/extending-default-theme#layout-slots
      "layout-bottom": () => {
        scrollableRegionsHaveKeyboardAccess();
        trackLinksAndFathomEvents();
      },
    });
  },
} satisfies Theme;
