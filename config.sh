##########################################################################################
#
# Halal Mode - DNS & Firewall Protector Magisk Module Configuration
# Module ID: halal_mode_haram_blocker
#
##########################################################################################

##########################################################################################
# Module Configuration
##########################################################################################
MODID=halal_mode_haram_blocker

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print "*******************************"
  ui_print "   Halal Mode DNS Protector    "
  ui_print "  v1.0 - DNS & Firewall Rules  "
  ui_print "*******************************"
}

##########################################################################################
# Replace list
##########################################################################################

# Not replacing any system directories - using Magisk's default merge behavior
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Default permissions for module files
  set_perm_recursive  $MODPATH  0  0  0755  0644

  # Make scripts executable
  set_perm  $MODPATH/common/service.sh  0  0  0755
  set_perm  $MODPATH/common/scripts/add_block.sh  0  0  0755
}
