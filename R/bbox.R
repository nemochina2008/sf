bb = function(xmin, xmax, ymin, ymax) {
	c(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax)
	# or return matrix instead, compatible to sp::bbox?
}

bbox.Mtrx = function(obj) {
	mn = apply(obj, 2, min)
	mx = apply(obj, 2, max)
	bb(xmin = mn[1], xmax = mx[1], ymin = mn[2], ymax = mx[2])
}
bbox.MtrxSet = function(obj) {
	s = sapply(obj, bbox.Mtrx)
	bb(xmin = min(s[1,]), xmax = max(s[2,]), ymin = min(s[3,]), ymax = max(s[4,]))
}
bbox.MtrxSetSet = function(obj) {
	s = sapply(obj, bbox.MtrxSet)
	bb(xmin = min(s[1,]), xmax = max(s[2,]), ymin = min(s[3,]), ymax = max(s[4,]))
}
bbox.MtrxSetSetSet = function(obj) {
	s = sapply(obj, bbox.MtrxSetSet)
	bb(xmin = min(s[1,]), xmax = max(s[2,]), ymin = min(s[3,]), ymax = max(s[4,]))
}

#' Return bounding of a simple feature or simple feature set
#'
#' Return bounding of a simple feature or simple feature set
#' @param obj object to compute the bounding box from
#' @export
bbox = function(obj) UseMethod("bbox") # not needed if sp exports bbox

#' @export
bbox.POINT = function(obj) bb(xmin = obj[1], xmax = obj[1], ymin = obj[2], ymax = obj[2])
#' @export
bbox.MULTIPOINT = bbox.Mtrx
#' @export
bbox.LINESTRING = bbox.Mtrx
#' @export
bbox.POLYGON = bbox.MtrxSet
#' @export
bbox.MULTILINESTRING = bbox.MtrxSet
#' @export
bbox.MULTIPOLYGON = bbox.MtrxSetSet
#' @export
bbox.GEOMETRYCOLLECTION = function(obj) {
	s = sapply(obj, bbox) # dispatch on class
	c(xmin = min(s[1,]), xmax = max(s[2,]), ymin = min(s[3,]), ymax = max(s[4,]))
}

#' @export
bbox.sfc = function(obj) {
	switch(class(obj)[1],
		"sfc_POINT" = bbox.Mtrx(do.call(rbind, obj)),
		"sfc_MULTIPOINT" = bbox.MtrxSet(obj),
		"sfc_LINESTRING" = bbox.MtrxSet(obj),
		"sfc_POLYGON" = bbox.MtrxSetSet(obj),
		"sfc_MULTILINESTRING" = bbox.MtrxSetSet(obj),
		"sfc_MULTIPOLYGON" =  bbox.MtrxSetSetSet(obj),
		"sfc_GEOMETRYCOLLECTION" = bbox.GEOMETRYCOLLECTION(obj),
		warning(paste("bbox: simple feature type", class(obj)[1], "not supported"))
	)
}

#' @export
bbox.sf = function(obj) bbox(geometry(obj))