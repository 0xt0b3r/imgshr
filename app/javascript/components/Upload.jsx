import React from 'react'

import Axios from 'axios'
import PromiseQueue from 'promise-queue'

import Icon from './Icon.jsx'
import ProgressBar from './ProgressBar.jsx'
import UploadList from './UploadList.jsx'

export default class Upload extends React.Component {
  constructor(props) {
    super(props)

    this.handleFiles = this.handleFiles.bind(this)
    this.upload = this.upload.bind(this)

    this.url = ''

    this.state = {
      selectedFiles: [],
      uploading: false,
      totalProgress: 0
    }
  }

  removeFile(i) {
    let files = this.state.selectedFiles
      .filter((_, k) => k !== i)
      .map((file) => file.obj)

    this.setState({
      selectedFiles: this.filesWithStatus(files)
    })
  }

  filesWithStatus(files) {
    let filesWithStatus = []
    files.forEach((file, i) => {
      filesWithStatus.push({
        obj: file,
        progress: 0,
        error: null,
        remove: () => this.removeFile(i)
      })
    })

    return filesWithStatus
  }

  handleFiles(event) {
    const files = Array.from(event.target.files)

    this.setState({
      selectedFiles: this.filesWithStatus(files)
    })
  }

  totalProgress() {
    const files = this.state.selectedFiles
    const progress = files
      .map((file) => file.progress)
      .reduce((a, b) => a + b, 0)

    return parseInt((progress / (files.length * 100)) * 100)
  }

  getRequestConfig(file) {
    return {
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      onUploadProgress: (e) => {
        file.progress = Math.round((e.loaded * 100) / e.total)
        // this.forceUpdate()

        this.setState({
          totalProgress: this.totalProgress()
        })
      }
    }
  }

  upload(event) {
    const files = this.state.selectedFiles
    const promises = []
    const queue = new PromiseQueue(2, Infinity)

    this.setState({uploading: true})

    files.forEach((file) => {
      const data = new FormData()
      const config = this.getRequestConfig(file)

      data.append(this.props.csrf.param, this.props.csrf.token)
      data.append('picture[image][]', file.obj)

      promises.push(queue.add(() => {
        return Axios.post(this.url, data, config)
      }))
    })

    Promise.all(promises)
      .then(() => {
        window.location.reload()
      })
  }

  uploadButtonClasses() {
    let classes = 'btn btn-success'

    if (!this.state.selectedFiles.length || this.state.uploading) {
      classes += ' disabled'
    }

    return classes
  }

  render() {
    return (
      <div>
        <div className="modal-body">
          <div className="alert alert-info">
            Please choose files for upload...
          </div>

          <input type="file" multiple onChange={this.handleFiles}/>

          <UploadList files={this.state.selectedFiles}/>

          <ProgressBar min="0" max="100" current={this.state.totalProgress} hide="true"/>
        </div>

        <div className="modal-footer">
          <button className={this.uploadButtonClasses()} type="submit" name="commit" onClick={this.upload}>
            <Icon name="upload"/>
            &nbsp;Upload!
          </button>

          <button className="btn btn-default" data-dismiss="modal">
            <Icon name="remove"/>
            &nbsp;Close
          </button>
        </div>
      </div>
    )
  }
}