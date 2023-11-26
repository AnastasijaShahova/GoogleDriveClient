//
//  FileInfoCell.swift
//  GoogleDrive
//
//  Created by Шахова Анастасия on 25.11.2023.
//

import UIKit
import GoogleAPIClientForREST
import Kingfisher

final class FileInfoTableViewCell: UITableViewCell {
    
    private let fileNameLabel = UILabel()
    private let fileSubtitleLabel = UILabel()
    private let fileSizeLabel = UILabel()
    private let documentImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ file: GTLRDrive_File) {
        
        fileNameLabel.text = file.name
        fileSubtitleLabel.text = ""
        
        if let modifiedTime = file.modifiedTime?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let formattedDate = dateFormatter.string(from: modifiedTime)
            fileSubtitleLabel.text = "Modified \(formattedDate)"
        }
        
        fileSizeLabel.text = ""
        if let size = file.size?.doubleValue.getSize() {
            fileSizeLabel.text = "\(size.toString) MB"
        } else {
            fileSizeLabel.text = ""
        }

        if file.hasThumbnail == true {
            documentImageView.kf.setImage(with: URL(string: file.thumbnailLink!))
        } else {
            documentImageView.kf.setImage(with: URL(string: file.iconLink!))
        }
    }
}

//MARK: - SetupConstraints
extension FileInfoTableViewCell {
    private func setupViews() {
        
        documentImageView.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fileSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        fileSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fileSizeLabel.font = UIFont.systemFont(ofSize: 11)
        fileSizeLabel.textColor = .gray
        fileSubtitleLabel.font = UIFont.systemFont(ofSize: 11)
        fileSubtitleLabel.textColor = .gray


        addSubview(documentImageView)
        addSubview(fileNameLabel)
        addSubview(fileSubtitleLabel)
        addSubview(fileSizeLabel)

        fileSizeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            documentImageView.widthAnchor.constraint(equalToConstant: photoSize.width),
            documentImageView.heightAnchor.constraint(equalToConstant: photoSize.height),
            documentImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            documentImageView.topAnchor.constraint(equalTo: topAnchor, constant: inset / 2 ),
            documentImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -inset / 2),

            fileNameLabel.leadingAnchor.constraint(equalTo: documentImageView.trailingAnchor, constant: inset),
            fileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            fileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),

            fileSubtitleLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor),
            fileSubtitleLabel.leadingAnchor.constraint(equalTo: documentImageView.trailingAnchor, constant: inset),

            fileSizeLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor),
            fileSizeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset / 2),
            fileSizeLabel.trailingAnchor.constraint(equalTo: fileNameLabel.trailingAnchor)
        ])
    }
}

private let photoSize = CGSize(width: 60, height: 60)
private let inset: CGFloat = 14

