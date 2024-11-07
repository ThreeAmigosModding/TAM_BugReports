import React from 'react';
import { theme } from './theme';
import '@mantine/core/styles.css';
import BugReport from './components/BugReport';
import ReactDOM from 'react-dom/client';
import { isEnvBrowser } from './utils/misc';
import { MantineProvider } from '@mantine/core';
import { VisibilityProvider } from './providers/VisibilityProvider';
import { emotionTransform, MantineEmotionProvider } from '@mantine/emotion';
import './index.css';

if (isEnvBrowser()) {
    const root = document.getElementById('root');

    // https://i.imgur.com/iPTAdYV.png - Night time img
    root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
    root!.style.backgroundSize = 'cover';
    root!.style.backgroundRepeat = 'no-repeat';
    root!.style.backgroundPosition = 'center';
    root!.style.zIndex = '0';
}

ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
        <VisibilityProvider>
            <MantineProvider theme={theme} stylesTransform={emotionTransform} defaultColorScheme="dark">
                <MantineEmotionProvider>
                    <BugReport />
                </MantineEmotionProvider>
            </MantineProvider>
        </VisibilityProvider>
    </React.StrictMode>,
);
