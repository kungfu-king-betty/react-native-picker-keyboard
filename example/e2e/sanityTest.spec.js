
/**
 * @format
 * @flow
 */

const {device, expect, element, by} = require('detox');

describe('Picker', () => {
  beforeAll(async () => {
    await device.launchApp({});
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should load example app with no errors and show all the examples by default', async () => {
    await expect(element(by.text('Picker Examples'))).toBeVisible();
  });
});
