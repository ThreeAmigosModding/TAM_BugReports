import { Box, Stack, Textarea, TextInput, NativeSelect, Grid, Button, Title, Divider } from '@mantine/core';
import { createStyles } from '@mantine/emotion';
import { debugData } from "../utils/debugData";
import { useForm } from '@mantine/form';
import { fetchNui } from '../utils/fetchNui';
import React, { useState, useEffect } from 'react'

debugData([
    {
        action: "setVisible",
        data: true,
    },
]);

const useStyles = createStyles((theme) => ({
    container: {
        width: '100%',
        height: '100%',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
    },

    main: {
        width: 700,
        height: 'fit',
        backgroundColor: theme.colors.dark[8],
        borderRadius: theme.radius.md,
    },

    title: {
        color: theme.colors.dark[0],
        textAlign: 'center',
    },
    titleContainer: {
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        paddingTop: 8,
        paddingBottom: 8,
    },

    btnContainer: {
        justifyContent: 'space-between',
        display: 'flex',
        marginTop: 16
    },

    input: {
        color: theme.colors.dark[0]
    }
}));

interface ReturnData {
    severity: Array<string>;
    types: Array<string>
}

const BugReport: React.FC = () => {
    const { classes } = useStyles();
    const [types, setTypes] = useState<Array<string>>(['Other', 'Graphics', 'UI', 'Performance', 'Audio', 'NPCs', 'Animation', 'Interaction', 'Terrain/Map', 'Vehicle', 'PVP']);
    const [severity, setSeverity] = useState<Array<string>>(['Low', 'Medium', 'High', 'Critical']);

    const form = useForm({
        mode: 'uncontrolled',
        initialValues: {
            title: '',
            type: '',
            severity: '',
            expectedResult: '',
            actualResult: '',
            reproduce: ''
        },
    });

    const handleSubmit = (values: typeof form.values) => {
        fetchNui('submit', values);
    };

    const handleCancel = async () => {
        await new Promise((resolve) => setTimeout(resolve, 200));
        form.reset();
        fetchNui('cancel');
    };

    useEffect(() => {
        fetchNui<ReturnData>("getConfigData").then((retData) => {
            setSeverity(retData.severity)
            setTypes(retData.types)
        })
    }, [])

    return (
        <>
            <Box className={classes.container}>
                <form onSubmit={form.onSubmit(handleSubmit)}>
                    <Box className={classes.main}>
                        <Box className={classes.titleContainer}>
                            <Title className={classes.title} order={2}>Report a Bug</Title>
                        </Box>
                        <Divider />
                        <Stack p={16} style={{ width: '100%' }} justify="space-between">
                            <TextInput
                                variant="filled"
                                radius="md"
                                label="Bug Report"
                                placeholder="What are you reporting?"
                                required={true}
                                classNames={{input: classes.input}}
                                key={form.key('title')}
                                {...form.getInputProps('title')}
                            />
                            <Grid>
                                <Grid.Col span={6}>
                                    <NativeSelect
                                        variant="filled"
                                        radius="md"
                                        label="Bug Type"
                                        description="The type of bug to report."
                                        required={true}
                                        data={types}
                                        key={form.key('type')}
                                        {...form.getInputProps('type')}
                                    />
                                </Grid.Col>
                                <Grid.Col span={6}>
                                    <NativeSelect
                                        variant="filled"
                                        radius="md"
                                        label="Bug Severity"
                                        description="The severity of the bug."
                                        required={true}
                                        data={severity}
                                        key={form.key('severity')}
                                        {...form.getInputProps('severity')}
                                    />
                                </Grid.Col>
                            </Grid>
                            <Textarea
                                variant="filled"
                                radius="md"
                                label="Expected Result"
                                required={true}
                                placeholder="The expected result of the action(s)."
                                classNames={{input: classes.input}}
                                key={form.key('expectedResult')}
                                {...form.getInputProps('expectedResult')}
                            />
                            <Textarea
                                variant="filled"
                                radius="md"
                                label="Actual Result"
                                required={true}
                                placeholder="The actual result of the action(s)."
                                classNames={{input: classes.input}}
                                key={form.key('actualResult')}
                                {...form.getInputProps('actualResult')}
                            />
                            <Textarea
                                variant="filled"
                                radius="md"
                                label="Steps to Reproduce"
                                required={true}
                                placeholder="The steps to reproduce this bug. Please be specific!"
                                classNames={{input: classes.input}}
                                key={form.key('reproduce')}
                                {...form.getInputProps('reproduce')}
                            />
                            <Box className={classes.btnContainer}>
                                <Button variant="filled" color="red.6" onClick={handleCancel}>
                                    Cancel
                                </Button>
                                <Button variant="filled" color="green.5" type="submit">
                                    Submit
                                </Button>
                            </Box>
                        </Stack>
                    </Box>
                </form>
            </Box>
        </>
    );
};

export default BugReport;