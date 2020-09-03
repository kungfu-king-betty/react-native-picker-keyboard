import * as React from "react"
import { TextStyle, StyleProp, ViewProps } from 'react-native'
import { ItemValue } from "./PickerKeyboard"

export interface PickerKeyboardIOSItemProps {
	label?: string;
	value?: number | string;
	color?: string;
	testID?: string;
}

declare class PickerKeyboardIOSItem extends React.Component<PickerKeyboardIOSItemProps, {}> {}

export interface PickerKeyboardIOSProps extends ViewProps {
	itemStyle?: StyleProp<TextStyle>;
	style?: StyleProp<TextStyle>;
	onChange?: React.SyntheticEvent<{itemValue: ItemValue, itemIndex: number}>;
	onValueChange?: (itemValue: ItemValue, itemIndex: number) => void;
	selectedValue?: ItemValue;
	testID?: string;
}

declare class PickerKeyboardIOS extends React.Component<PickerKeyboardIOSProps, {}> {
	static Item: typeof PickerKeyboardIOSItem
}

export { PickerKeyboardIOS };
