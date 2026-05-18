$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:9090/")
$listener.Start()
Write-Host "Server running at http://localhost:9090/"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = $ctx.Request.Url.LocalPath.TrimStart("/")
    if (-not $path -or $path -eq "") { $path = "index.html" }
    $file = Join-Path "c:\Magia\WEB" $path
    if (Test-Path $file) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $ctx.Response.ContentType = "text/html"
        $ctx.Response.ContentLength64 = $bytes.Length
        $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $ctx.Response.StatusCode = 404
    }
    $ctx.Response.Close()
}
