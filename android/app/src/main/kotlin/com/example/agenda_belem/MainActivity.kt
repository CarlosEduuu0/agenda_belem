package com.example.agenda_belem

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        criarCanalDeNotificacao()
    }

    /// Android 8+ exige um canal. Importância ALTA = a notificação aparece
    /// como pop-up na tela, o que facilita a demonstração no vídeo.
    private fun criarCanalDeNotificacao() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val canal = NotificationChannel(
            "agenda_belem_eventos",
            "Eventos de Belém",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Avisos sobre novos eventos e lembretes da agenda"
        }
        getSystemService(NotificationManager::class.java)
            .createNotificationChannel(canal)
    }
}
