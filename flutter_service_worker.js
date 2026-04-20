'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/assets/courses/template.md": "3f1897addd09bf8a12ce4575b2a5fdfb",
"assets/assets/courses/test.md": "b3ade42d0c218b9fe81277ac077bd0da",
"assets/assets/markdown/argo.md": "590ed1a04117a1ace915e1ca0a0b2754",
"assets/assets/markdown/terrain.md": "d29b384b54debe98b929bc1f4d9d57fe",
"assets/assets/markdown/pngchaser.md": "672bdc767ecca321193615cb6f8bbb39",
"assets/assets/markdown/subwayscholar.md": "87b19427f64408ce36bc6f6c1e584e9c",
"assets/assets/markdown/zombies.md": "4564a337d49d97fb6c7a8aafc1316754",
"assets/assets/markdown/airobic.md": "95e8ababa0d3e481e9c06b6d9bc3df4c",
"assets/assets/markdown/pacman.md": "56c862c7667beed960ffbec66298bcf5",
"assets/assets/markdown/urbanize.md": "55836c2facd7fa2cdb92bee6711d7186",
"assets/assets/markdown/collider.md": "5de9e4fdf08edbc336ac1882e471130a",
"assets/assets/markdown/courses.md": "3f1897addd09bf8a12ce4575b2a5fdfb",
"assets/assets/fonts/CustomIcons.ttf": "a3506ead2bef9b3abcaa32e1a202f976",
"assets/assets/fonts/JetBrainsMono-Regular.ttf": "d09f65145228b709a10fa0a06d522d89",
"assets/assets/logo.svg": "8d2567a36b622c8dc62d04f9be83a713",
"assets/assets/images/profile.jpg": "4bc22fb60dca5f52c6cb036124f334dd",
"assets/assets/images/row.jpg": "253d9206984da1a0bef1c11222d684a8",
"assets/assets/images/projects/terrain/finishedDrawing.jpg": "9d803588e0db411353bc3a043b0a06e7",
"assets/assets/images/projects/terrain/toonIsland.jpg": "1be2bca73f6eb1339915a06fad2bef18",
"assets/assets/images/projects/terrain/userInterface.jpg": "d9ea7dbfd5e58b895e4216c390edd8ff",
"assets/assets/images/projects/terrain/topIsland.jpg": "9e7f1cb93d85769a81f312d68c8916b9",
"assets/assets/images/projects/terrain/coolIsland.jpg": "ddc2f66d4f31299d3a5c8172be2b9743",
"assets/assets/images/projects/zombies/wiz.jpg": "03284101d9cadaf99b91e3e3656b4738",
"assets/assets/images/projects/zombies/legs.gif": "b8931471c04df73c87a0f8e37d51bdcc",
"assets/assets/images/projects/zombies/head.png": "931a2c6d88a77a27ff04dfdff99965c2",
"assets/assets/images/projects/zombies/legs_walk.png": "0f53d2c8ea90064021aff69699984b86",
"assets/assets/images/projects/zombies/sword.gif": "23d81252c346ec26a0e81fbae4a7753c",
"assets/assets/images/projects/zombies/run.gif": "faceabbe5b16511436718d4d7a9f5839",
"assets/assets/images/projects/zombies/alc.jpg": "6e5988ed35d3205398fea4c9bba4610b",
"assets/assets/images/projects/zombies/pathfinding.png": "e6cde022ee0461eb27d3dc8f94ec9b26",
"assets/assets/images/projects/zombies/enchant_glint.png": "ce903e82a7cbc37cfaa06dd1af35bff3",
"assets/assets/images/projects/zombies/enchant_effect.gif": "2153aa1ac9a192b114caa2fa7230d9a0",
"assets/assets/images/projects/zombies/hands.gif": "70ed9563c3cac8dfc646b670d19464aa",
"assets/assets/images/projects/zombies/shoulders.gif": "01396a9926b8ea466a748fe32bbb5ae4",
"assets/assets/images/projects/zombies/nin.jpg": "d5b4367a094f6d4a031a1451ea4e1d02",
"assets/assets/images/projects/urbanize/wealthy_lively_2.jpg": "e4b59e93119a07cbf5ca55348f2ca6d2",
"assets/assets/images/projects/urbanize/wealthy_lively.jpg": "a441f1db3287c6a7a2fde4e34f2073cd",
"assets/assets/images/projects/urbanize/algo.jpg": "cd6172aa247cb356e9d792b7df4db1b2",
"assets/assets/images/projects/urbanize/base_gan.jpg": "a4b685756daf6fb7c89aa4bda3f3dc84",
"assets/assets/images/projects/pngchaser/chaser_lurking.png": "e77c3e2b6adcf3a42afdecbf411c72d8",
"assets/assets/images/projects/pngchaser/explode.gif": "b95900ecad24bff71a84d527ede2a8fc",
"assets/assets/images/projects/pngchaser/hgrid.png": "a0aa453f1ad054b43e02f4653f816269",
"assets/assets/images/projects/collider/skeletal_ui.png": "c7649191e3b5b67bd834eb5719884aeb",
"assets/assets/images/projects/collider/backflip.gif": "5a0655e82e9d1e24c7dde96a05fe0040",
"assets/assets/images/projects/collider/static_ui.png": "33d2c3641807c0a76d8db45b83217a6d",
"assets/assets/images/projects/collider/export.png": "296e4ebe3d23387195aa11e638c5542a",
"assets/assets/images/projects/argo/coach_dashboard.png": "62e79e6959105f519face960e7f24557",
"assets/assets/images/projects/pacman/generatedBoard2.png": "44350f499d5dad228ff5f2077f7e55d9",
"assets/assets/images/projects/pacman/boardLayout2.png": "f03a9695f5d19edd2c32ba8d8f43837c",
"assets/assets/images/projects/pacman/corner.png": "6e57a7680a91caddaeef2256cd55ce18",
"assets/assets/images/projects/pacman/line.png": "c8a38a7cf5491d0f2474d59d02db581e",
"assets/assets/images/projects/pacman/screenshot.png": "120ea41f359c3119f39913bf752ca701",
"assets/assets/images/projects/pacman/generatedBoard.png": "b11aed1369309324cc31fab5952d36c5",
"assets/assets/images/projects/pacman/boardLayout.png": "c8c39caf5e892e27d17da4be578c5b72",
"assets/assets/images/projects/airobic/plan.jpg": "db600ba307ce2b7966a325f3f88fa175",
"assets/assets/images/projects/airobic/home.jpg": "c903d761cafafe1aaaaed7e7c38d0d67",
"assets/assets/images/projects/airobic/workout_generator.jpg": "5afa55af2b6c70e365a5a1130eb23973",
"assets/assets/images/fish.jpg": "61892e13df9858300056e2eaff108e58",
"assets/assets/images/banners/zombies.jpg": "f02b6577cbb825066910dfc4849cf957",
"assets/assets/images/banners/collider.jpg": "75b020cd6b0486d0aaa5cc865966843d",
"assets/assets/images/banners/pngchaser.jpg": "392951a345c16ea9a4ed2b01336251b4",
"assets/assets/images/banners/subwayscholar.png": "e10b69a7d943c9fe9ed793bf63724752",
"assets/assets/images/banners/terrainpainter.jpg": "02d365e39a9d029cd0d4238bb49d25b8",
"assets/assets/images/banners/pacman.jpg": "4a022539595875b252094bcb1d6fa85e",
"assets/assets/images/banners/urbanize.jpg": "7f833af363f7f345cdfb7278ee0abdb0",
"assets/assets/images/banners/argo.jpg": "be5ddb1866b46d9fd0e972654d84aecd",
"assets/assets/images/banners/airobic.jpg": "f3eff1bdafdfa24042307bc7655ad981",
"assets/assets/images/contact_qr.png": "8cde82b719ea1d022a144a5d4b02c61a",
"assets/assets/images/pink.jpg": "834419beedce4236fce2aa4f3b7b22ba",
"assets/assets/images/headshot.jpg": "98d8aaa68b8a1babbd71563facbe60cb",
"assets/assets/images/tahoe.jpg": "23fc1e7a19841e68dd305334cf6b9bfd",
"assets/assets/images/grad.jpg": "4dd51cb65d8505924485300c22be8b19",
"assets/assets/Resume_Marcus_Winter.pdf": "4abfd1d5f68929c27b44aacbd3868686",
"assets/AssetManifest.bin.json": "8e70cccab8004bd8e36b9c5e0703407c",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "a82f3a5e266e6ae4bde63d7ed90c1eb9",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "c6819efa093e60a71ff3f36d0e1234a4",
"assets/packages/media_kit/assets/web/hls1.4.10.js": "bd60e2701c42b6bf2c339dcf5d495865",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/fonts/MaterialIcons-Regular.otf": "977707cd9254bda35dc352de9ce1fb85",
"assets/AssetManifest.bin": "4807e1af21b0d2c8b04bd55a10eb70d5",
"assets/NOTICES": "a019d6017516faf406ce54f26246180f",
"assets/FontManifest.json": "5e6b6aa663ffbc652ab7571d9b827594",
"favicon.png": "ab49e594fd9113bd2d4d6ee41d314982",
"manifest.json": "f2217ab6fd0b100084c8f1799ab7c90e",
"favicon.svg": "56bc40a78ca16737b6d8eb179a87f91c",
"index.html": "9d01bd710e7c123c1798b13240a8b705",
"/": "9d01bd710e7c123c1798b13240a8b705",
"404.html": "3bf30b760e2f03a2e27e2babf90e2173",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "ccacad5b92d3f2265e0182dd027d53a5",
"main.dart.js": "c824b2e85aca41a53d75f0661834fd32",
"version.json": "980547175e325fe622a3362b84d55b6a",
"icons/Icon-maskable-512.png": "c94e6fd2ac9440860224ad6f8a6c10c4",
"icons/Icon-maskable-192.png": "d388adb77e0ad215cc567e8e3ca71b76",
"icons/Icon-512.png": "c94e6fd2ac9440860224ad6f8a6c10c4",
"icons/Icon-192.png": "d388adb77e0ad215cc567e8e3ca71b76"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
