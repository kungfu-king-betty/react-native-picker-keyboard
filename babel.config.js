module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
  plugins: [
    [
      'module-resolver',
      {
        alias: {
          'react-native-picker-keyboard': './js',
        },
        cwd: 'babelrc',
      },
    ],
  ],
};
