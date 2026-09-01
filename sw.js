"use strict";

var CACHE_NAME = "teamlage-offline-v3";
var APP_SHELL = [
  "./index.html",
  "./manifest.json",
  "./icon-192.png",
  "./icon-512.png"
];

self.addEventListener("install", function (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      return cache.addAll(APP_SHELL);
    }).then(function () {
      return self.skipWaiting();
    })
  );
});

self.addEventListener("activate", function (event) {
  event.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(
        keys
          .filter(function (key) { return key !== CACHE_NAME; })
          .map(function (key) { return caches.delete(key); })
      );
    }).then(function () {
      return self.clients.claim();
    })
  );
});

// Cache-first, damit die App auch offline sofort und zuverlässig lädt.
// Kachel-Bilder und die Leaflet-Bibliothek (Live-Karte) werden ebenfalls
// zwischengespeichert, sobald sie einmal online geladen wurden – so bleiben
// bereits angesehene Kartenausschnitte auch offline nutzbar. Nicht besuchte
// Bereiche der Live-Karte bleiben offline naturgemäß leer.
self.addEventListener("fetch", function (event) {
  if (event.request.method !== "GET") return;

  event.respondWith(
    caches.match(event.request).then(function (cached) {
      if (cached) return cached;
      return fetch(event.request).then(function (response) {
        var cacheable = response
          && (response.ok || response.type === "opaque");
        if (cacheable) {
          var copy = response.clone();
          caches.open(CACHE_NAME).then(function (cache) {
            cache.put(event.request, copy);
          });
        }
        return response;
      }).catch(function () {
        if (event.request.mode === "navigate") {
          return caches.match("./index.html");
        }
      });
    })
  );
});
