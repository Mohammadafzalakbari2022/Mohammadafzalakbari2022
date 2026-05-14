import { Controller, Get } from '@nestjs/common';

/** Public catalog directory stub (`plan-14`). No auth — safe read-only metadata. */
@Controller('catalog')
export class CatalogController {
  @Get('public')
  publicCatalog() {
    const sharingOff = process.env.CATALOG_SHARING_DEFAULT === 'false';
    return {
      schema_version: 1,
      items: [] as unknown[],
      catalog_sharing_default: !sharingOff,
    };
  }
}
