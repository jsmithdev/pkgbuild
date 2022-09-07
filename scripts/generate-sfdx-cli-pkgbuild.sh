#!/usr/bin/env bash

set -euf -o pipefail

OUTPUT_DIR=${1:-`pwd`}

# Get and parse the manifest file from Salesforce
x64_manifest_content=$(curl -s https://developer.salesforce.com/media/salesforce-cli/sfdx/channels/stable/sfdx-linux-x64-buildmanifest)
sfdx_version=$(echo "$x64_manifest_content" | jq '.version')
sfdx_download_x86_64_url=$(echo "$x64_manifest_content" | jq '.gz')
sfdx_download_x86_64_sha256=$(echo "$x64_manifest_content" | jq '.sha256gz')
arm_manifest_content=$(curl -s https://developer.salesforce.com/media/salesforce-cli/sfdx/channels/stable/sfdx-linux-arm-buildmanifest)
sfdx_download_arm_url=$(echo "$arm_manifest_content" | jq '.gz')
sfdx_download_arm_sha256=$(echo "$arm_manifest_content" | jq '.sha256gz')

if [ -f "${OUTPUT_DIR}/PKGBUILD" ]; then
    current_version=$(grep "pkgver=" "${OUTPUT_DIR}/PKGBUILD" | cut -d'=' -f2)
    if [ "$current_version" = "$sfdx_version" ]; then
        # In case we want to bump the pkgrel version manually to fix something,
        # we don't want this script to overwrite that pkgrel back to 1, so we
        # will short circuit the script
        exit 0
    fi
fi

# Generate PKGBUILD based on template
cat << EOF > "${OUTPUT_DIR}/PKGBUILD"
# Maintainer: Dang Mai <contact at dangmai dot net>

pkgname=sfdx-cli
pkgver=${sfdx_version}
pkgrel=1
_dirname="\${pkgname}-v\${pkgver}"
pkgdesc="a tool for creating and managing Salesforce DX projects from the command line"
arch=('x86_64')
url="https://developer.salesforce.com/tools/sfdxcli"
license=('unknown')
optdepends=('gnome-keyring: saving default credentials')
provides=('sfdx-cli')
options=(!strip)
conflicts=()
source_x86_64=(${sfdx_download_x86_64_url})
source_arm=(${sfdx_download_arm_url})

package() {
    cd "\${srcdir}"

    install -dm 755 "\${pkgdir}"/opt
    install -dm 755 "\${pkgdir}"/usr/bin
    sfdx_dir="sfdx"
    cp -a "\${sfdx_dir}" "\${pkgdir}"/opt/sfdx-cli
    ln -s /opt/sfdx-cli/bin/sfdx "\${pkgdir}"/usr/bin/sfdx
    ln -s /opt/sfdx-cli/bin/sf "\${pkgdir}"/usr/bin/sf
}
sha256sums_x86_64=(${sfdx_download_x86_64_sha256})
sha256sums_arm=(${sfdx_download_arm_sha256})
EOF
