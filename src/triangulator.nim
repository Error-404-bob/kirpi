#   MIT License - Copyright (c) 2025 Eray Zesen
#   Github: https://github.com/erayzesen/kirpi
#   License information: https://github.com/erayzesen/kirpi/blob/master/LICENSE

type
  Vec2* = object
    x*, y*: float64

  Triangle* = object
    a*, b*, c*: Vec2

# ---------------- Vector operations ----------------
proc `-`(a,b:Vec2): Vec2 = Vec2(x:a.x-b.x, y:a.y-b.y)
proc cross(a,b:Vec2): float64 = a.x*b.y - a.y*b.x

# ---------------- Reflex / ear tests ----------------
proc isReflex(prev,curr,next:Vec2): bool =
  cross(curr - prev, next - curr) < 0.0

proc pointInTriangle(p,a,b,c:Vec2): bool =
  # half-space method
  let ab = b - a
  let bc = c - b
  let ca = a - c
  let ap = p - a
  let bp = p - b
  let cp = p - c
  let c1 = cross(ab, ap)
  let c2 = cross(bc, bp)
  let c3 = cross(ca, cp)
  (c1 >= 0 and c2 >= 0 and c3 >= 0) or (c1 <= 0 and c2 <= 0 and c3 <= 0)

# ---------------- Triangulation ----------------
proc triangulate*(poly: seq[Vec2]): seq[Triangle] =
  let n = poly.len
  if n < 3: return @[]
  if n == 3: return @[Triangle(a:poly[0],b:poly[1],c:poly[2])]

  var idx = newSeq[int](n)
  for i in 0..<n: idx[i] = i

  var reflex = newSeq[bool](n)
  proc updateReflex(i:int) =
    let L = idx[(i-1+idx.len) mod idx.len]
    let C = idx[i]
    let R = idx[(i+1) mod idx.len]
    reflex[C] = isReflex(poly[L], poly[C], poly[R])

  for i in 0..<idx.len: updateReflex(i)

  var res: seq[Triangle] = @[]
  res.setLen(0)
  var iterations = 0
  let maxIter = n*5

  while idx.len > 3:
    iterations.inc
    if iterations > maxIter: break

    var earFound = false

    for i in 0..<idx.len:
      let pi = idx[(i-1+idx.len) mod idx.len]
      let ci = idx[i]
      let ni = idx[(i+1) mod idx.len]

      if reflex[ci]: continue

      let A = poly[pi]
      let B = poly[ci]
      let C = poly[ni]

      var bad = false
      for v in idx:
        if v==pi or v==ci or v==ni: continue
        if reflex[v] and pointInTriangle(poly[v],A,B,C):
          bad = true
          break
      if bad: continue

      res.add Triangle(a:A,b:B,c:C)
      idx.delete(i)

      # update reflex for neighbors
      if idx.len > 2:
        updateReflex((i-1+idx.len) mod idx.len)
        updateReflex(i mod idx.len)

      earFound = true
      break

    if not earFound:
      # fallback for degenerate or self-intersecting polygons
      let a = idx[0]
      let b = idx[1]
      let c = idx[2]
      res.add Triangle(a:poly[a],b:poly[b],c:poly[c])
      idx.delete(1)

  if idx.len == 3:
    res.add Triangle(a:poly[idx[0]],b:poly[idx[1]],c:poly[idx[2]])

  return res
