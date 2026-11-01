"""Check and render the built review paper; this does not prove mathematics.

Requires pypdf, pypdfium2, and Pillow. The laptop's ignored pdfinspect package
directory is accepted as a fallback. No dependencies are downloaded here.
"""
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re
import sys

if not __debug__:
    raise RuntimeError('Run document checks without -O or PYTHONOPTIMIZE.')

ROOT = Path(__file__).resolve().parents[1]
PAPER = ROOT/'paper'
OUT = ROOT/'research/short_paper_build'
PREVIEW = ROOT/'research/local_validation/phd_audit/paper_preview'
STEM = 'prescribed_repeatable_completion'
LOCAL_PACKAGES = ROOT/'research/local_validation/phd_audit/paper_tools/pdfinspect'
if LOCAL_PACKAGES.is_dir():
    sys.path.insert(0,str(LOCAL_PACKAGES))
from pypdf import PdfReader
import pypdfium2 as pdfium
from PIL import Image, ImageDraw


def text_hash(path):
    return hashlib.sha256(path.read_text(encoding='utf-8').encode('utf-8')).hexdigest()


def main():
    manifest = json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
    for name, expected in manifest['source_hashes'].items():
        assert text_hash(ROOT/name) == expected, name
    for suffix,key in [('tex','tex_sha256'),('md','rendered_markdown_sha256')]:
        assert text_hash(PAPER/f'{STEM}.{suffix}') == manifest[key]
    pdf = PAPER/f'{STEM}.pdf'
    pdf_hash = hashlib.sha256(pdf.read_bytes()).hexdigest()
    assert pdf_hash == manifest['pdf_sha256']
    source = (PAPER/'arxiv_ready.md').read_text(encoding='utf-8')
    tex = (PAPER/f'{STEM}.tex').read_text(encoding='utf-8')
    title = source.splitlines()[0].removeprefix('# ')
    author = re.search(r'\*\*Author:\*\*\s*(.+)',source).group(1).strip()
    tags = [int(n) for n in re.findall(r'\\tag\{(\d+)\}',source)]
    assert tags == list(range(1,len(tags)+1))
    for opening,closing in [(r'\[',r'\]'),(r'\(',r'\)')]:
        assert source.count(opening) == source.count(closing)
    for key in manifest['citations_used']:
        assert f'ref-{key}' in tex, key
    log = (OUT/f'{STEM}.log').read_text(encoding='utf-8')
    findings = re.findall(r'^.*(?:Overfull|Missing character|undefined references|Citation .* undefined).*$',log,re.M)
    assert not findings, findings
    reader = PdfReader(pdf)
    assert reader.metadata.title == title
    assert reader.metadata.author == author
    extracted = [page.extract_text() or '' for page in reader.pages]
    assert all(len(text) > 80 for text in extracted)
    combined = '\n\n'.join(extracted)
    for marker in ['2.33690021','2.33690023','Proposition 6','VIBE MATH','Eldar']:
        assert re.sub(r'\s+','',marker) in re.sub(r'\s+','',combined), marker
    # Check the numerical assertions newly brought into the paper against
    # the retained exact certificate outputs, never their floating proposals.
    family = json.loads((ROOT/'research/completion_switch_family_2026-11-01/verification.json').read_text(encoding='utf-8'))
    crossover = json.loads((ROOT/'research/completion_crossover_2026-11-01/verification.json').read_text(encoding='utf-8'))
    assert family['result'] == crossover['result'] == 'PASS'
    assert Fraction(family['uniform_alpha_lower']['exact']) > Fraction(9,10)
    assert Fraction(family['endpoint_results'][0]['strict_separation']['exact']) > Fraction(5,10000)
    assert Fraction(family['endpoint_results'][1]['strict_separation']['exact']) > Fraction(9,100000)
    assert [Fraction(x['exact']) for x in crossover['bracket']] == [Fraction('2.33690021'),Fraction('2.33690023')]
    # Tie those report values to the unchanged certificate and proof sources.
    for name,expected in crossover['source_text_sha256'].items():
        assert text_hash(ROOT/name) == expected, name
    PREVIEW.mkdir(parents=True,exist_ok=True)
    (PREVIEW/'extracted.txt').write_text(combined,encoding='utf-8')
    document = pdfium.PdfDocument(str(pdf))
    columns, thumb_width, thumb_height = 3, 360, 530
    sheet = Image.new('RGB',(columns*thumb_width,((len(document)+columns-1)//columns)*thumb_height),'#d0d0d0')
    draw = ImageDraw.Draw(sheet)
    for i in range(len(document)):
        page = document[i]
        bitmap = page.render(scale=1.5)
        picture = bitmap.to_pil().convert('RGB')
        picture.save(PREVIEW/f'page_{i+1}.png')
        picture.thumbnail((thumb_width-12,thumb_height-30))
        x,y = (i%columns)*thumb_width,(i//columns)*thumb_height
        sheet.paste(picture,(x+6,y+22))
        draw.text((x+8,y+5),f'Page {i+1}',fill='black')
        bitmap.close()
        page.close()
    sheet.save(PREVIEW/'contact_sheet.png')
    document.close()
    report = dict(result='PASS',pdf_sha256=pdf_hash,pages=len(extracted),title=title,author=author,
                  page_extracted_character_counts=[len(x) for x in extracted],
                  numbered_equations=len(tags),resolved_reference_keys=manifest['citations_used'],
                  latex_overflow_missing_character_or_undefined_reference_findings=findings,
                  source_and_pdf_hashes_match_build_manifest=True,pdf_pages_rendered=len(extracted),
                  proposition_6_numbers_match_exact_reports=True,
                  checker_text_sha256=text_hash(Path(__file__).resolve()),
                  scope='Document integrity and consistency with retained exact results; not a proof or external review.',
                  compiler_environment_note='Fontconfig configuration/cache messages are reported; compilation and rendering succeed.')
    (OUT/'document_checks.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(f'PASS {len(extracted)} PDF pages; {len(tags)} numbered equations; {len(manifest["citations_used"])} references; hashes and certified comparisons match.')


if __name__ == '__main__':
    main()
