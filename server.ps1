param(
  [int]$Port = 8420,
  [string]$Root = $PSScriptRoot
)

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")

try {
  $listener.Start()
} catch {
  # Läuft vermutlich bereits (Port belegt) - einfach beenden, nichts zu tun.
  exit
}

$mimeMap = @{
  ".html" = "text/html; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".js"   = "application/javascript; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".png"  = "image/png"
  ".ico"  = "image/x-icon"
  ".svg"  = "image/svg+xml"
}

while ($listener.IsListening) {
  try {
    $context = $listener.GetContext()
  } catch {
    break
  }
  $request = $context.Request
  $response = $context.Response
  $path = $request.Url.AbsolutePath
  if ($path -eq "/") { $path = "/index.html" }
  $relative = $path.TrimStart("/") -replace "/", [IO.Path]::DirectorySeparatorChar
  $filePath = Join-Path $Root $relative

  # Ausbruch aus dem App-Ordner verhindern.
  $fullRoot = (Resolve-Path $Root).Path
  $resolved = $null
  if (Test-Path $filePath -PathType Leaf) {
    $resolved = (Resolve-Path $filePath).Path
  }

  if ($resolved -and $resolved.StartsWith($fullRoot)) {
    $ext = [IO.Path]::GetExtension($filePath)
    $contentType = $mimeMap[$ext]
    if (-not $contentType) { $contentType = "application/octet-stream" }
    try {
      $bytes = [IO.File]::ReadAllBytes($filePath)
      $response.ContentType = $contentType
      $response.ContentLength64 = $bytes.Length
      $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } catch {
      $response.StatusCode = 500
    }
  } else {
    $response.StatusCode = 404
  }
  $response.OutputStream.Close()
}
