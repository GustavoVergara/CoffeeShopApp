package com.example.coffeeshop.android

import android.os.Bundle
import android.os.Debug
import android.util.Log
import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.sp
import com.example.coffeeshop.Greeting


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    GreetingView(Greeting().greet())
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        if (BuildConfig.DEBUG) { // don't even consider it otherwise
            if (Debug.isDebuggerConnected()) {
                Log.d(
                    "SCREEN",
                    "Keeping screen on for debugging, detach debugger and force an onResume to turn it off."
                )
                window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            } else {
                window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                Log.d("SCREEN", "Keeping screen on for debugging is now deactivated.")
            }
        }
    }
}

@Composable
fun GreetingView(text: String) {
    Text(text = text)
}

@Composable
fun MenuItem(image: ImageBitmap, title: String, description: String) {
    Row {
        Image(bitmap = image, contentDescription = title)
        Column {
            Text(text = title, fontSize = 24.sp)
            Text(text = description)
        }
    }
}

@Preview(showBackground = true, device = "spec:width=411dp,height=891dp")
@Composable
fun DefaultPreview() {
    MyApplicationTheme {
        MenuItem("Cappuccino", "Feito com leite cremoso e café expresso")
    }
}
