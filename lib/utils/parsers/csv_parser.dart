String csvToMarkdownTable(String csv) {
  final lines = csv.trim().split('\n');
  if (lines.isEmpty) return '';

  final buffer = StringBuffer();

  for (int i = 0; i < lines.length; i++) {
    // Regex for the supported delimiters ',' and ';'
    final cells =
        (lines[i].split(RegExp(r'[,;]'))).map((cell) => cell.trim()).toList();

    buffer.writeln('| ${cells.join(' | ')} |');

    // Add separator after header row
    if (i == 0) {
      buffer.writeln('| ${cells.map((_) => '---').join(' | ')} |');
    }
  }

  return buffer.toString();
}
