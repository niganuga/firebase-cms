import * as functions from 'firebase-functions';

export const onFileUploaded = functions.storage.object().onFinalize(async (object) => {
  // Handle file upload
  console.log('File uploaded:', object.name);
});
