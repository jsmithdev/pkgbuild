#!/usr/bin/env bash

set -euf -o pipefail

OUTPUT_DIR=${1:-`pwd`}

# Get and parse the manifest file from Salesforce
x64_manifest_content=$(curl -s https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-linux-x64-buildmanifest)
sf_version=$(echo "$x64_manifest_content" | jq '.version')
sf_download_x86_64_url=$(echo "$x64_manifest_content" | jq '.gz')
sf_download_x86_64_sha256=$(echo "$x64_manifest_content" | jq '.sha256gz')
arm_manifest_content=$(curl -s https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-linux-arm-buildmanifest)
sf_download_arm_url=$(echo "$arm_manifest_content" | jq '.gz')
sf_download_arm_sha256=$(echo "$arm_manifest_content" | jq '.sha256gz')

if [ -f "${OUTPUT_DIR}/PKGBUILD" ]; then
    current_version=$(grep "pkgver=" "${OUTPUT_DIR}/PKGBUILD" | cut -d'=' -f2)
    if [ "$current_version" = "$sf_version" ]; then
        # In case we want to bump the pkgrel version manually to fix something,
        # we don't want this script to overwrite that pkgrel back to 1, so we
        # will short circuit the script
        exit 0
    fi
fi

# Generate PKGBUILD based on template
cat << EOF > "${OUTPUT_DIR}/PKGBUILD"
# Maintainer: Jamie Smith <aur at jsmith dot dev>

pkgname=sf-cli
pkgver=${sf_version}
pkgrel=1
_dirname="\${pkgname}-v\${pkgver}"
pkgdesc="a tool for creating and managing Salesforce DX projects from the command line"
arch=('x86_64' 'arm')
url="https://developer.salesforce.com/tools/sfcli"
license=('unknown')
optdepends=('gnome-keyring: saving default credentials')
provides=('sf-cli')
options=(!strip)
conflicts=()
source_x86_64=(${sf_download_x86_64_url})
source_arm=(${sf_download_arm_url})

package() {
    cd "\${srcdir}"

    install -dm 755 "\${pkgdir}"/opt
    install -dm 755 "\${pkgdir}"/usr/bin
    sf_dir="sf"
    cp -a "\$sf_dir}" "\${pkgdir}"/opt/sf-cli
    ln -s /opt/sf-cli/bin/sf "\${pkgdir}"/usr/bin/sf
    ln -s /opt/sf-cli/bin/sf "\${pkgdir}"/usr/bin/sf
}
sha256sums_x86_64=(${sf_download_x86_64_sha256})
sha256sums_arm=(${sf_download_arm_sha256})
EOF
