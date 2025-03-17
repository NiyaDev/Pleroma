
module pleroma::bulk;


<* Value storage *>
struct BulkEntry {
  char[] value;
}

<* Cleans up BulkEntry *>
fn void BulkEntry.free(&self) {
  free(self.value);
}

