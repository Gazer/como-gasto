package ar.com.p39.como_gasto

import android.os.Bundle

import io.flutter.app.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
