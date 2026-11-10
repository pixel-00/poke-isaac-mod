local mod = RegisterMod("My Mod", 1)
local hiddenItemManager = require("lib.hidden_item_manager")

hiddenItemManager:Init(mod)

-- Collectibles
include("scripts.collectibles.lifeOrb")
include("scripts.collectibles.amuletCoin")
include("scripts.collectibles.hiddenMachine")
include("scripts.collectibles.bubbleBeam")
include("scripts.collectibles.leftovers")
include("scripts.collectibles.redMap")
include("scripts.collectibles.trafficCone")
include("scripts.collectibles.coconutWater")
include("scripts.collectibles.foolsMap")
include("scripts.collectibles.luckyStar")
include("scripts.collectibles.promoOffer")
include("scripts.collectibles.tabulaRasa")
include("scripts.collectibles.temperTantrum")
include("scripts.collectibles.pairODice")
include("scripts.collectibles.lazyBones")
include("scripts.collectibles.junkFood")
include("scripts.collectibles.earlyOnset")
include("scripts.collectibles.couchCushion")
include("scripts.collectibles.looseFeathers")
include("scripts.collectibles.flySwatter")
include("scripts.collectibles.technicalMachine")
include("scripts.collectibles.technicalRecord")
include("scripts.collectibles.abilityCapsule")
include("scripts.collectibles.chestOfChests")

-- Ability Capsule Passives
include("scripts.collectibles.abilities.hugePower")
include("scripts.collectibles.abilities.intimidate")
include("scripts.collectibles.abilities.levitate")--
include("scripts.collectibles.abilities.pickup")---
include("scripts.collectibles.abilities.flashFire")--
include("scripts.collectibles.abilities.regenerator")
include("scripts.collectibles.abilities.technician")
include("scripts.collectibles.abilities.weakArmor")--add cacheflag
include("scripts.collectibles.abilities.sereneGrace")
include("scripts.collectibles.abilities.speedBoost")--save boost progress?
include("scripts.collectibles.abilities.stall")
include("scripts.collectibles.abilities.parentalBond")
include("scripts.collectibles.abilities.effectSpore")
include("scripts.collectibles.abilities.cheekPouch")--adjusted animation, added (false) phd synergy
include("scripts.collectibles.abilities.soulHeart")--
include("scripts.collectibles.abilities.sturdy")
include("scripts.collectibles.abilities.slowStart")--add callback for speed, saves between exiting
include("scripts.collectibles.abilities.overgrow")--
include("scripts.collectibles.abilities.blaze")--
include("scripts.collectibles.abilities.torrent")--
include("scripts.collectibles.abilities.hustle")
include("scripts.collectibles.abilities.emergencyExit")
include("scripts.collectibles.abilities.intrepidSword")
include("scripts.collectibles.abilities.dauntlessShield")
include("scripts.collectibles.abilities.beastBoost")
include("scripts.collectibles.abilities.pickpocket")
include("scripts.collectibles.abilities.plusMinus")--rework
include("scripts.collectibles.abilities.megaLauncher")--slight rework
include("scripts.collectibles.abilities.stamina")

-- Trinkets
include("scripts.trinkets.focusSash")
include("scripts.trinkets.keyCrusher")
include("scripts.trinkets.choiceBand")
include("scripts.trinkets.choiceSpecs")
include("scripts.trinkets.choiceScarf")
include("scripts.trinkets.airBalloon")