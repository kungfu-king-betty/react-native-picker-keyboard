import React, { Component } from 'react';

import PickerKeyboardComponent from './PickerKeyboard';


class PickerKeyboard extends Component {
    render() {
        return <PickerKeyboardComponent {...this.props} />;
    }
}

export default PickerKeyboard;
