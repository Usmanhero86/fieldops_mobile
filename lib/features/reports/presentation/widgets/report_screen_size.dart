/// Breakpoint enum shared across all report widgets.
///
/// Narrow  < 400 dp  (small Android phones, 320–399 dp)
/// Normal  400–599 dp (standard phones)
/// Wide   >= 600 dp  (tablets / landscape)
enum ReportScreenSize { narrow, normal, wide }

ReportScreenSize reportScreenSize(double width) {
  if (width < 400) return ReportScreenSize.narrow;
  if (width < 600) return ReportScreenSize.normal;
  return ReportScreenSize.wide;
}
