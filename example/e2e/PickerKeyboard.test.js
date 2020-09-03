/**
 * @format
 */

const {device, expect, element, by} = require('detox');

describe('PickerKeyboard', () => {
  beforeAll(async () => {
    await device.launchApp({});
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should be selectable by ID', async () => {
    await expect(element(by.id('basic-picker-keyboard'))).toBeVisible();
  });
});
