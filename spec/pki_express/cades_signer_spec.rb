require_relative '../spec_helper'

module PkiExpress
  class CadesSigner < Signer
    def invoke(command, args = [], _plain_output)
      { command: command, args: args }
    end
  end
end

module PkiExpress
  describe CadesSigner do
    let(:cades_signer) { PkiExpress::CadesSigner.new }

    describe 'initializer' do
      it { expect(cades_signer).to be_a(PkiExpress::CadesSigner) }
      it { expect(cades_signer.encapsulated_content).to be_truthy }
      it { expect(cades_signer.encapsulated_content).to be_truthy }
      it { expect(cades_signer.commitment_type).to be_falsey }
      it { expect(cades_signer.overwrite_original_file).to be_falsey }

      it do
        expect(cades_signer.instance_variable_get(:@version_manager))
          .to be_a(PkiExpress::VersionManager)
      end
    end

    describe '#pdf_to_sign_path=' do
      context 'when the file exists' do
        it do
          expect { cades_signer.pdf_to_sign_path = ('./spec/fixtures/invalid.pdf') }
            .to raise_error(StandardError, 'The provided file to be signed was not found')
        end
      end

      context 'when the file does not exist' do
        it do
          cades_signer.pdf_to_sign_path = ('./spec/fixtures/sample.file')

          expect(cades_signer.instance_variable_get(:@pdf_to_sign_path))
            .to eq('./spec/fixtures/sample.file')
        end
      end
    end

    describe '#sign' do
      let(:cades_signer) { PkiExpress::CadesSigner.new }

      before do
        cades_signer.pdf_to_sign_path = ('./spec/fixtures/sample.file')
        cades_signer.output_file_path = ('/tmp/output.file')

        allow(cades_signer).to receive(:verify_and_add_common_options).and_return(true)
      end

      it do
        expect(cades_signer.sign).to eq(
          command: 'sign-cades',
          args: %w[./spec/fixtures/sample.file /tmp/output.file]
        )
      end

      context 'when overwrite_original_file is true' do
        it do
          cades_signer.overwrite_original_file = true

          expect(cades_signer.sign).to eq(
            command: 'sign-cades',
            args: %w[./spec/fixtures/sample.file --overwrite]
          )
        end
      end

      context 'when encapsulated_content is not true' do
        it do
          cades_signer.encapsulated_content = false

          expect(cades_signer.sign).to eq(
            command: 'sign-cades',
            args: %w[./spec/fixtures/sample.file /tmp/output.file --detached]
          )
        end
      end

      context 'when commitment_type is true' do
        it do
          cades_signer.commitment_type = true

          expect(cades_signer.sign).to eq(
            command: 'sign-cades',
            args: [
              './spec/fixtures/sample.file',
              '/tmp/output.file',
              '--commitment-type',
              true
            ]
          )
        end
      end

      context 'when get_cert is true' do
        let(:version_manager) { cades_signer.instance_variable_get(:@version_manager) }

        before do
          allow(version_manager).to receive(:require_version).and_call_original
        end

        it do
          begin; cades_signer.sign(true); rescue; end

          expect(version_manager).to have_received(:require_version).with('1.8').once
        end
      end

      context 'when get_cert is not true' do
        let(:version_manager) { cades_signer.instance_variable_get(:@version_manager) }

        before do
          allow(version_manager).to receive(:require_version).and_call_original
        end

        it do
          cades_signer.sign(false)

          expect(version_manager).to have_received(:require_version).with('1.3').once
        end
      end
    end
  end
end
