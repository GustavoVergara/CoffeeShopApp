package com.example.coffeeshop

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform