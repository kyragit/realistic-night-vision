package com.kyraryk.realisticnightvision;

import com.mojang.blaze3d.platform.InputConstants;
import com.mojang.logging.LogUtils;

import net.minecraft.client.KeyMapping;
import net.minecraft.client.Minecraft;
import net.minecraft.client.renderer.PostChain;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.sounds.SoundEvent;
import net.minecraft.world.effect.MobEffects;
import net.minecraftforge.client.ClientRegistry;
import net.minecraftforge.client.settings.KeyConflictContext;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.common.util.Lazy;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.event.TickEvent.ClientTickEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;

import org.slf4j.Logger;

@Mod("realisticnightvision")
public class RealisticNightVision {
    public static final Logger LOGGER = LogUtils.getLogger();
    public static final String MODID = "realisticnightvision";
    public static final Lazy<KeyMapping> SWITCH_MODE_KEY = Lazy.of(() -> new KeyMapping(
        "Switch Night Vision Mode", KeyConflictContext.IN_GAME, 
        InputConstants.getKey("key.keyboard.m"), "Realistic Night Vision"
    ));
    private static boolean isGreen = true;
    private static boolean shouldHaveEffect = false;

    public RealisticNightVision() {
        MinecraftForge.EVENT_BUS.register(this);
        FMLJavaModLoadingContext.get().getModEventBus().addListener(this::setupClient);
    }

    private void setupClient(final FMLClientSetupEvent event) {
        ClientRegistry.registerKeyBinding(SWITCH_MODE_KEY.get());
    }

    public static void toggle(Boolean on) {
        if (on) {
            String path = isGreen ? "shaders/post/night_vision_green.json" : "shaders/post/night_vision_white.json";
            Minecraft.getInstance().gameRenderer.loadEffect(new ResourceLocation(MODID, path));
        } else {
            Minecraft.getInstance().gameRenderer.shutdownEffect();
        }
    }

    public static boolean hasEffectNow() {
        PostChain effect = Minecraft.getInstance().gameRenderer.currentEffect();
        if (effect == null) {
            return false;
        }
        return effect.getName().startsWith(MODID);
    }

    @SubscribeEvent
    public void onClientTick(ClientTickEvent event) {
        if (event.phase == TickEvent.Phase.START) {
            if (Minecraft.getInstance().player != null) {
                shouldHaveEffect = Minecraft.getInstance().player.hasEffect(MobEffects.NIGHT_VISION);
            }
        }
        if (event.phase == TickEvent.Phase.END) {
            boolean now = hasEffectNow();
            if (shouldHaveEffect && !now) {
                toggle(true);
            }
            if (!shouldHaveEffect && now) {
                toggle(false);
            }
            while (SWITCH_MODE_KEY.get().consumeClick()) {
                if (shouldHaveEffect) {
                    isGreen = !isGreen;
                    toggle(true);
                    if (Minecraft.getInstance().player != null) {
                        Minecraft.getInstance().player.playSound(new SoundEvent(new ResourceLocation(MODID, "switch_mode")), 1f, 1f);
                    }
                }
            }
        }
    }
}
