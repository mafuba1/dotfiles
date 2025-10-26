/*
 * Also applied
 * games https://github.com/bakkeby/patches/blob/master/dwm/dwm-games-6.6.diff
 * bottomstack https://dwm.suckless.org/patches/bottomstack/
*/

/* Bar functionality */
#include "bar_indicators.c"
#include "bar_tagicons.c"
#include "bar.c"

#include "bar_ltsymbol.c"
#include "bar_status.c"
#include "bar_winicon.c"
#include "bar_tags.c"
#include "bar_wintitle.c"

/* Other patches */
#include "attachx.c"
#include "decorationhints.c"
#include "ipc.c"
#ifdef VERSION
#include "ipc/IPCClient.c"
#include "ipc/yajl_dumps.c"
#include "ipc/ipc.c"
#include "ipc/util.c"
#endif
#include "pertag.c"
#include "restartsig.c"
#include "tapresize.c"
#include "vanitygaps.c"
#include "seamless_restart.c"
/* Layouts */
#include "layout_facts.c"
// #include "layout_centeredmaster.c"
// #include "layout_centeredfloatingmaster.c"
// #include "layout_grid.c"
// #include "layout_horizgrid.c"
#include "layout_monocle.c"
#include "layout_tile.c"

