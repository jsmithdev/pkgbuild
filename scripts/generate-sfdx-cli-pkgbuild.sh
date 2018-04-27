#!/usr/bin/env bash

set -euf -o pipefail

OUTPUT_DIR=${1:-`pwd`}

# Get and parse the manifest file from Salesforce
manifest_content=$(curl https://developer.salesforce.com/media/salesforce-cli/manifest.json)
sfdx_original_version=$(echo "$manifest_content" | jq '.version')
# PKGBUILD pkgver does not accept dash, so we convert that to underscore
sfdx_version=${sfdx_original_version//-/_}
sfdx_download_i686_url=$(echo "$manifest_content" | jq '.archives."linux-x86".url')
sfdx_download_i686_sha256=$(echo "$manifest_content" | jq '.archives."linux-x86".sha256')
sfdx_download_x86_64_url=$(echo "$manifest_content" | jq '.archives."linux-x64".url')
sfdx_download_x86_64_sha256=$(echo "$manifest_content" | jq '.archives."linux-x64".sha256')

# Generate PKGBUILD based on template
cat << EOF > "${OUTPUT_DIR}/PKGBUILD"
# Maintainer: Dang Mai <contact at dangmai dot net>

pkgname=sfdx-cli
pkgver=${sfdx_version}
pkgrel=1
_dirname="\${pkgname}-v\${pkgver}"
pkgdesc="a tool for creating and managing Salesforce DX projects from the command line"
arch=('i686' 'x86_64')
url="https://developer.salesforce.com/tools/sfdxcli"
license=('unknown')
optdepends=()
provides=('sfdx-cli')
conflicts=()
source_i686=(${sfdx_download_i686_url})
source_x86_64=(${sfdx_download_x86_64_url})

package() {
    _arch=""
    case \$CARCH in
        "x86_64")
            _arch="x64"
            ;;
        "i686")
            _arch="x86"
            ;;
    esac

    cd "\${srcdir}"

    install -dm 755 "\${pkgdir}"/opt
    install -dm 755 "\${pkgdir}"/usr/bin
    sfdx_dir="sfdx-cli-v${sfdx_original_version}-linux-\${_arch}"
    cp -a "\${sfdx_dir}" "\${pkgdir}"/opt/sfdx-cli
    ln -s /opt/sfdx-cli/bin/sfdx "\${pkgdir}"/usr/bin/sfdx
}
sha256sums_i686=(${sfdx_download_i686_sha256})
sha256sums_x86_64=(${sfdx_download_x86_64_sha256})
EOF
pushd "${OUTPUT_DIR}"
makepkg --printsrcinfo > .SRCINFO
popd
