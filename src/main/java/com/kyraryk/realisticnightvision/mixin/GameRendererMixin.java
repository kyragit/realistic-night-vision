package com.kyraryk.realisticnightvision.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

import net.minecraft.client.renderer.GameRenderer;
import net.minecraft.world.entity.LivingEntity;

@Mixin(GameRenderer.class)
public class GameRendererMixin {
    @Inject(at = @At("HEAD"), method = "getNightVisionScale(Lnet/minecraft/world/entity/LivingEntity;F)F", cancellable = true)
    private static void getNightVisionScale(LivingEntity living, float num, CallbackInfoReturnable<Float> callback) {
        callback.setReturnValue(0f);
    }
}
