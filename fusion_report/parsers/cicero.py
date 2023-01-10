"""Cicero module"""
from typing import Any, Dict, List, Optional, Tuple

from fusion_report.parsers.abstract_fusion import AbstractFusionTool


class Cicero(AbstractFusionTool):
    """CICERO tool parser."""

    def set_header(self, header: str, delimiter='\t'):
        self.header: List[str] = header.strip().split(delimiter)

    def parse(self, line: str, delimiter: Optional[str] = '\t') -> List[Tuple[str, Dict[str, Any]]]:
        col: List[str] = [x.strip() for x in line.split(delimiter)]
        fusion: str = "--".join([col[self.header.index('geneA')],col[self.header.index('geneB')]])
        details: Dict[str, Any] = {
            'position': "#".join([
                ":".join([col[self.header.index('chrA')],col[self.header.index('posA')]]),
                ":".join([col[self.header.index('chrB')],col[self.header.index('posB')]]),
            ]).replace('chr', ''),
            'score': float(col[self.header.index('score')]),
            'rating': col[self.header.index('rating')],
            'featureA': col[self.header.index('featureA')],
            'featureB': col[self.header.index('featureB')],
            'coverageA': col[self.header.index('coverageA')],
            'coverageB': col[self.header.index('coverageB')],
            'type': col[self.header.index('type')],
            'function_effect': col[self.header.index('functional effect')],
        }

        return [(fusion, details)]